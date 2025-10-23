module ShiftRegister8bit (
    input clk,
    input enable,
    input reset,
    input S,
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (reset) begin
            Q <= 8'b0;
        end else if (enable) begin
            Q <= {Q[6:0], S};  // Efficient vector shift with enable
        end
    end
endmodule

module Mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    assign out = data[sel];  // Optimal direct-index mux
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

    // Instantiate shift register with reset tied low
    ShiftRegister8bit sr_inst (
        .clk(clk),
        .enable(enable),
        .reset(1'b0),
        .S(S),
        .Q(Q)
    );

    // Instantiate multiplexer
    Mux8to1 mux_inst (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule