// Control Module: Orchestrates load and shift operations
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

    reg [3:0] q_reg;
    wire [3:0] load_data;
    wire [3:0] shift_data;

    // Generate load and shift data using assign statements
    assign load_data = data;
    assign shift_data = {1'b0, q_reg[3:1]};

    // Asynchronous reset, synchronous load and shift operations
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            q_reg <= 4'b0;
        end else if (load) begin
            q_reg <= load_data;
        end else if (ena) begin
            q_reg <= shift_data;
        end else begin
            q_reg <= q_reg;
        end
    end

    // Assign output
    assign q = q_reg;

endmodule