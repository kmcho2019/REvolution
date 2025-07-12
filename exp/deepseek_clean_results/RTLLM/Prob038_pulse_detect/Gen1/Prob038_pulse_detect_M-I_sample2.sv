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

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        data_out <= 0;  // Default output
        
        case (state)
            IDLE: begin
                if (data_in == 0)
                    state <= GOT_0;
            end
            
            GOT_0: begin
                if (data_in == 1)
                    state <= GOT_1;
                else
                    state <= GOT_0;  // Stay if we get another 0
            end
            
            GOT_1: begin
                if (data_in == 0) begin
                    state <= IDLE;
                    data_out <= 1;   // Pulse detected
                end
                // Stay in GOT_1 if we get another 1
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule