module EnhancedShiftRegister (
    input clk,
    input enable,
    input S,
    input load,          // Not used but available for extension
    input [7:0] data_in, // Not used but available for extension
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            if (load) begin
                Q <= data_in;  // Parallel load capability
            end else begin
                Q <= {Q[6:0], S};  // Shift operation
            end
        end
    end
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    wire [7:0] Q;
    wire [1:0] mux_sel_upper = {A, B};
    
    // Enhanced shift register with unused parallel load tied off
    EnhancedShiftRegister sr_inst (
        .clk(clk),
        .enable(enable),
        .S(S),
        .load(1'b0),
        .data_in(8'b0),
        .Q(Q)
    );
    
    // First level muxes (4x 2:1)
    wire [1:0] mux_level1;
    assign mux_level1[0] = C ? Q[{mux_sel_upper,1'b1}] : Q[{mux_sel_upper,1'b0}];
    assign mux_level1[1] = C ? Q[{mux_sel_upper,1'b1}] : Q[{mux_sel_upper,1'b0}];
    
    // Final output mux (2:1)
    assign Z = (A & B) ? mux_level1[1] : mux_level1[0];
endmodule