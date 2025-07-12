// TopModule: Top-level module
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

    reg [3:0] q_reg;
    wire [3:0] next_q;

    // Priority encoder to handle load and enable signals
    wire load_priority = load | (ena & ~load);

    // FSM-based approach to handle load, shift, and idle operations
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 4'b0;
        end else if (load) begin
            q_reg <= data;
        end else if (ena & ~load) begin
            q_reg <= {1'b0, q_reg[3:1]};
        end else begin
            q_reg <= q_reg;
        end
    end

    // Assign output
    assign q = q_reg;

endmodule