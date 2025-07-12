module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

// Synchronizer registers for inputs
reg [1:0] valid_in_sync;
reg [7:0] data_in_sync;

// Internal state and storage
reg [7:0] data_lock;
reg state; // 0: IDLE, 1: READY

// Synchronize inputs
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_in_sync <= 2'b00;
        data_in_sync <= 8'b0;
    end else begin
        valid_in_sync <= {valid_in_sync[0], valid_in};
        data_in_sync <= data_in;
    end
end

// Main state machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 1'b0;
        data_lock <= 8'b0;
        valid_out <= 1'b0;
        data_out <= 16'b0;
    end else begin
        // Default outputs
        valid_out <= 1'b0;
        
        case (state)
            1'b0: begin // IDLE state
                if (valid_in_sync[1]) begin
                    data_lock <= data_in_sync;
                    state <= 1'b1;
                end
            end
            
            1'b1: begin // READY state
                if (valid_in_sync[1]) begin
                    data_out <= {data_lock, data_in_sync};
                    valid_out <= 1'b1;
                    state <= 1'b0;
                end
            end
        endcase
    end
end

endmodule