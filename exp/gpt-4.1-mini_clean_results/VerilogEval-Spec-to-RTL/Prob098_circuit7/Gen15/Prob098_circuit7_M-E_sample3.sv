module TopModule (
    input clk,
    input a,
    output reg q
);
    reg initialized; // Flag to mark if initial capture is done

    always @(posedge clk) begin
        if (!initialized) begin
            q <= ~a;         // On first clock edge, capture inverted 'a'
            initialized <= 1; // Mark initialization done
        end
        else begin
            q <= q;          // Hold value afterward
        end
    end
endmodule