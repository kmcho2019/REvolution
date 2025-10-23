module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
localparam IDLE  = 2'b00;
localparam GOT_0 = 2'b01;
localparam GOT_1 = 2'b10;

reg [1:0] state;

// State transition and output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        case (state)
            IDLE: begin
                data_out <= 1'b0;
                if (data_in == 1'b0)
                    state <= GOT_0;
            end
            GOT_0: begin
                data_out <= 1'b0;
                if (data_in == 1'b1)
                    state <= GOT_1;
                else
                    state <= GOT_0;  // Stay if consecutive 0s
            end
            GOT_1: begin
                if (data_in == 1'b0) begin
                    data_out <= 1'b1;  // Complete pulse detected
                    state <= IDLE;
                end
                else begin
                    data_out <= 1'b0;
                    state <= IDLE;    // Reset if we get 1 after GOT_1
                end
            end
            default: begin
                state <= IDLE;
                data_out <= 1'b0;
            end
        endcase
    end
end

endmodule