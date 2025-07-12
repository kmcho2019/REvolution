// TopModule: Novel 4-bit shift register architecture using multiplexers and flip-flops
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]   q         // Output data
);

// Internal signals for multiplexer selection
wire [1:0] sel;

// Assign selection signals based on input controls
assign sel = (load) ? 2'b10 : (ena) ? 2'b01 : (areset) ? 2'b00 : 2'b00;

// 4-bit shift register using flip-flops
reg [3:0] q_reg;

// Multiplexers for each bit position
always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_reg <= 4'b0;
    end else begin
        case (sel)
            2'b10: q_reg <= data; // Load operation
            2'b01: begin
                q_reg[3] <= 1'b0;
                q_reg[2] <= q_reg[3];
                q_reg[1] <= q_reg[2];
                q_reg[0] <= q_reg[1];
            end // Shift operation
            default: q_reg <= q_reg; // Hold current value
        endcase
    end
end

// Assign output
assign q = q_reg;

endmodule