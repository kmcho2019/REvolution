module TopModule(
    input wire c,
    input wire d,
    output wire [3:0] mux_in
);

// 2-to-1 mux function
function mux2to1;
    input sel;
    input in0;
    input in1;
    begin
        mux2to1 = sel ? in1 : in0;
    end
endfunction

wire d_not;
assign d_not = mux2to1(d, 1'b1, 1'b0);  // d' = if d=0 output 1 else 0

// function_00 = mux(c, 1, d') = c ? 1 : d'
wire function_00;
assign function_00 = mux2to1(c, d_not, 1'b1);

// function_01 = 0
wire function_01 = 1'b0;

// function_11 = mux(c, d, 0) = c ? d : 0
wire function_11;
assign function_11 = mux2to1(c, 1'b0, d);

// function_10 = mux(d, c, 1) = d ? c : 1
wire function_10;
assign function_10 = mux2to1(d, 1'b1, c);

assign mux_in = {function_10, function_11, function_01, function_00};

endmodule