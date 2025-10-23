module TopModule(
    input x,
    input y,
    output logic z
);
    always_comb begin
        z = ~(x ^ y);
    end
endmodule