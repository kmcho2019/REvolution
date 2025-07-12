module TopModule(
    input x,
    input y,
    output logic z
);
    always @(*) begin
        // Logic comparison using an always block
        z = (x == y); // Note: === is for exact comparison but == is used here for simplicity
    end
endmodule