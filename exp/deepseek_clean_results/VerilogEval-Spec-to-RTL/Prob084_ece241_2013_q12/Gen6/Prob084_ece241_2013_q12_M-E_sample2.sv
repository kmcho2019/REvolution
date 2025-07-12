module CircularBuffer8bit (
    input clk,
    input enable,
    input S,
    output [7:0] Q,
    output [2:0] pointer
);
    reg [7:0] memory;
    reg [2:0] wr_ptr;
    
    always @(posedge clk) begin
        if (enable) begin
            memory[wr_ptr] <= S;
            wr_ptr <= wr_ptr + 1;  // Automatic wrap-around
        end
    end
    
    assign Q = memory;
    assign pointer = wr_ptr;
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
    wire [2:0] pointer;  // Not used, but available for debug
    
    CircularBuffer8bit cb_inst (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q),
        .pointer(pointer)
    );
    
    // Direct mux implementation using ABC as index
    assign Z = Q[{A, B, C}];
endmodule