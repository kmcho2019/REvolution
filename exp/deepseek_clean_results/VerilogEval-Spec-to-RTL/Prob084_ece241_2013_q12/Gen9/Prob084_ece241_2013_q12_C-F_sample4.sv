module PowerOptimizedShiftRegister #(parameter WIDTH = 8) (
    input clk,
    input enable,
    input S,
    output [WIDTH-1:0] Q
);
    reg [WIDTH-1:0] reg_data;
    
    always @(posedge clk) begin
        if (enable) begin
            reg_data <= {reg_data[WIDTH-2:0], S};
        end
    end

    assign Q = reg_data;
endmodule

module TimingOptimizedMux #(parameter WIDTH = 8) (
    input [WIDTH-1:0] data,
    input [$clog2(WIDTH)-1:0] sel,
    output out
);
    // Binary tree implementation (better timing)
    generate
        if (WIDTH == 8) begin
            wire [3:0] stage1 = sel[2] ? data[7:4] : data[3:0];
            wire [1:0] stage2 = sel[1] ? stage1[3:2] : stage1[1:0];
            assign out = sel[0] ? stage2[1] : stage2[0];
        end
        /* Alternative direct index (better area for small WIDTH)
        else begin
            assign out = data[sel];
        end
        */
    endgenerate
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

    PowerOptimizedShiftRegister #(8) sr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    TimingOptimizedMux #(8) mux (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule