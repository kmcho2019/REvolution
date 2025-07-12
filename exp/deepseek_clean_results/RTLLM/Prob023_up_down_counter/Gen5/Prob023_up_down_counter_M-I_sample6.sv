module up_down_counter #(
    parameter WIDTH = 16
) (
    input clk,
    input reset,
    input up_down,
    input enable,       // Optional clock gating control
    output reg [WIDTH-1:0] count
);

// Gray code conversion
wire [WIDTH-1:0] next_count;
wire [WIDTH-1:0] gray_count;

// Shared arithmetic unit
assign next_count = up_down ? count + 1'b1 : count - 1'b1;

// Binary to Gray conversion
assign gray_count = next_count ^ (next_count >> 1);

always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};
    end else if (enable) begin
        // Carry-select style implementation (4x4 bits)
        count[3:0] <= up_down ? count[3:0] + 1'b1 : count[3:0] - 1'b1;
        
        // Upper nibbles with carry propagation
        count[7:4] <= up_down ? 
            (count[3:0] == 4'hF ? count[7:4] + 1'b1 : count[7:4]) :
            (count[3:0] == 4'h0 ? count[7:4] - 1'b1 : count[7:4]);
            
        count[11:8] <= up_down ? 
            ({count[7:4],count[3:0]} == 8'hFF ? count[11:8] + 1'b1 : count[11:8]) :
            ({count[7:4],count[3:0]} == 8'h00 ? count[11:8] - 1'b1 : count[11:8]);
            
        count[15:12] <= up_down ? 
            ({count[11:8],count[7:4],count[3:0]} == 12'hFFF ? count[15:12] + 1'b1 : count[15:12]) :
            ({count[11:8],count[7:4],count[3:0]} == 12'h000 ? count[15:12] - 1'b1 : count[15:12]);
    end
end

endmodule