module synchronizer (
    input wire clk_a,
    input wire clk_b,
    input wire arstn,
    input wire brstn,
    input wire [3:0] data_in,
    input wire data_en,
    output reg [3:0] dataout,
    output reg data_valid
);

    // Clock domain A registers
    reg [3:0] data_reg;
    reg req_a;
    wire [1:0] gray_req = {req_a, req_a ^ data_en}; // Gray code generation
    
    always @(posedge clk_a or negedge arstn) begin
        if (!arstn) begin
            data_reg <= 4'b0;
            req_a <= 1'b0;
        end else begin
            data_reg <= data_in; // Always capture data when enabled
            req_a <= data_en;    // Direct assignment
        end
    end

    // Clock domain B synchronization
    reg [1:0] sync_shift; // Combined synchronizer shift register
    wire ack_b = sync_shift[1] ^ sync_shift[0]; // Gray to binary conversion
    
    // Data path (combinational)
    wire [3:0] next_dataout = ack_b ? data_reg : dataout;
    
    always @(posedge clk_b or negedge brstn) begin
        if (!brstn) begin
            sync_shift <= 2'b00;
            dataout <= 4'b0;
            data_valid <= 1'b0;
        end else begin
            // Two-stage sync as shift register
            sync_shift <= {sync_shift[0], gray_req[1]};
            
            // Update outputs
            dataout <= next_dataout;
            data_valid <= ack_b;
        end
    end

endmodule