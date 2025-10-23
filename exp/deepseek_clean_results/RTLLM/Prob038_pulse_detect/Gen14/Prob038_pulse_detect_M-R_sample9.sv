module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output data_out
);

// Binary state encoding
localparam [1:0] IDLE   = 2'b00;
localparam [1:0] GOT_0  = 2'b01;
localparam [1:0] GOT_01 = 2'b10;

reg [1:0] state;

// Output is purely combinational based on current state and input
assign data_out = (state == GOT_01) && !data_in;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (!data_in) state <= GOT_0;
            end
            GOT_0: begin
                if (data_in) state <= GOT_01;
                // Stay in GOT_0 if input remains 0
            end
            GOT_01: begin
                if (!data_in) state <= IDLE;
                else state <= GOT_01;  // Stay if input remains 1
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule