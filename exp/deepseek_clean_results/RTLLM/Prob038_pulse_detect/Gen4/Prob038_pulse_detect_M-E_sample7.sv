module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

reg [1:0] sync_chain;
reg [1:0] state;

// State encoding
localparam IDLE  = 2'b00;
localparam SAW_0 = 2'b01;
localparam SAW_1 = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sync_chain <= 2'b00;
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        // Synchronize input
        sync_chain <= {sync_chain[0], data_in};
        
        // State transitions
        case (state)
            IDLE: begin
                data_out <= 1'b0;
                if (sync_chain[1] == 1'b0)
                    state <= SAW_0;
            end
            
            SAW_0: begin
                if (sync_chain[1] == 1'b1)
                    state <= SAW_1;
                else
                    state <= SAW_0;  // Stay if we see consecutive 0s
            end
            
            SAW_1: begin
                if (sync_chain[1] == 1'b0) begin
                    data_out <= 1'b1;
                    state <= IDLE;
                end
                else begin
                    state <= IDLE;  // Reset if we see consecutive 1s
                end
            end
            
            default: state <= IDLE;
        endcase
    end
end

endmodule