module TopModule(d, ena, q);
    input d;
    input ena;
    output reg q;

    always @(*) begin
        if (ena) begin
            q = d;
        end else begin
            // No need to assign anything here, q keeps its previous value
        end
    end
endmodule