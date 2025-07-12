module CircularShiftRegister (
    input clk,
    input enable,
    input S,
    output [7:0] Q,
    output [2:0] write_ptr
);
    reg [7:0] memory;
    reg [2:0] ptr;

    always @(posedge clk) begin
        if (enable) begin
            memory[ptr] <= S;
            ptr <= ptr + 1;
        end
    end

    // Virtual reordering of outputs based on write pointer
    assign Q = {
        memory[(ptr + 0) % 8],
        memory[(ptr + 1) % 8],
        memory[(ptr + 2) % 8],
        memory[(ptr + 3) % 8],
        memory[(ptr + 4) % 8],
        memory[(ptr + 5) % 8],
        memory[(ptr + 6) % 8],
        memory[(ptr + 7) % 8]
    };
    
    assign write_ptr = ptr;
endmodule

module HierarchicalMux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    wire [1:0] stage1;
    
    // First stage: 4-to-1 muxes
    assign stage1[0] = sel[1:0] == 2'b00 ? data[0] :
                      sel[1:0] == 2'b01 ? data[1] :
                      sel[1:0] == 2'b10 ? data[2] : data[3];
                      
    assign stage1[1] = sel[1:0] == 2'b00 ? data[4] :
                      sel[1:0] == 2'b01 ? data[5] :
                      sel[1:0] == 2'b10 ? data[6] : data[7];
    
    // Final stage: 2-to-1 mux
    assign out = sel[2] ? stage1[1] : stage1[0];
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
    wire [2:0] sel = {A, B, C};
    wire [2:0] write_ptr; // Not used but available for debug

    CircularShiftRegister csr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q),
        .write_ptr(write_ptr)
    );

    HierarchicalMux8to1 mux (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule