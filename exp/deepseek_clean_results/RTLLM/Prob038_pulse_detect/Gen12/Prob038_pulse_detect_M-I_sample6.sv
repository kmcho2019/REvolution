module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// States
localparam IDLE   = 2'b00;
localparam GOT_0  = 2'b01;
localparam GOT_01 = 2'b10;

reg [1:0] state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        data_out <= 1'b0; // Default output
        
        case (state)
            IDLE: begin
                if (data_in == 1'b0)
                    state <= GOT_0;
            end
            
            GOT_0: begin
                if (data_in == 1'b1)
                    state <= GOT_01;
                else if (data_in == 1'b0)
                    state <= GOT_0;  // Stay if consecutive 0s
                else
                    state <= IDLE;
            end
            
            GOT_01: begin
                if (data_in == 1'b0) begin
                    data_out <= 1'b1; // Pulse complete
                    state <= IDLE;    // Ready for new pulse
                end
                else begin
                    state <= IDLE;    // Broken sequence
                end
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule