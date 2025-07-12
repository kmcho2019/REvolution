// Load Module: Handles loading data into the shift register
module LoadModule (
    input   [3:0]    data,     // Input data to load
    output  [3:0]    q         // Loaded data
);

    assign q = data;

endmodule

// Shift Module: Performs the right shift operation
module ShiftModule (
    input   [3:0]    data,     // Data to shift
    output  [3:0]    q         // Shifted data
);

    assign q = {1'b0, data[3:1]};

endmodule

// Control Module: Orchestrates load and shift operations
module ControlModule (
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

    // Instantiate load and shift modules
    LoadModule load_module (.data(data), .q(load_data));
    ShiftModule shift_module (.data(q_reg), .q(shift_data));

    // Asynchronous reset, synchronous load and shift operations with clock gating
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

// TopModule: Top-level module
module TopModule (
    input           clk,      // Clock signal
    input           areset,   // Asynchronous reset signal
    input           load,     // Load signal
    input           ena,      // Enable signal
    input   [3:0]    data,     // Input data
    output  [3:0]    q         // Output data
);

    // Instantiate control module
    ControlModule control_module (.clk(clk), .areset(areset), .load(load), .ena(ena), .data(data), .q(q));

endmodule