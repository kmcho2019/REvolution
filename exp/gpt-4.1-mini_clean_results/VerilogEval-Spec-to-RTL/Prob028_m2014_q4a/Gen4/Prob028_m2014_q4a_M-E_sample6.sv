module TopModule(
    input d,
    input ena,
    output reg q
);
    always @(ena or d) begin
        q <= ena ? d : q; // Transparent when ena=1, holds value otherwise
    end
endmodule