module CircularShiftRegister (
    input clk,
    input enable,
    input S,
    output [7:0] Q
);
    reg [7:0] reg_data;
    wire gated_clk = clk & enable;

    always @(posedge gated_clk) begin
        reg_data <= {reg_data[6:0], S};
    end

    assign Q = reg_data;
endmodule

module SmartMux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    wire upper_nibble = sel[2];
    wire [1:0] nibble_sel = sel[1:0];
    
    wire [3:0] selected_nibble = upper_nibble ? data[7:4] : data[3:0];
    assign out = selected_nibble[nibble_sel];
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

    CircularShiftRegister csr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    SmartMux8to1 mux (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule