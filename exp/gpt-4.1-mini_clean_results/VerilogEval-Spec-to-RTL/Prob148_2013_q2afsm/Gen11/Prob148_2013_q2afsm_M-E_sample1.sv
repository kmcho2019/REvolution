module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    reg A, B, C, D;
    reg A_next, B_next, C_next, D_next;

    // State register with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn) begin
            A <= 1'b1;
            B <= 1'b0;
            C <= 1'b0;
            D <= 1'b0;
        end else begin
            A <= A_next;
            B <= B_next;
            C <= C_next;
            D <= D_next;
        end
    end

    // Next-state logic
    always @(*) begin
        // Default no transitions
        A_next = 1'b0;
        B_next = 1'b0;
        C_next = 1'b0;
        D_next = 1'b0;

        if (A) begin
            if (r[0]) begin
                B_next = 1'b1;
            end else if (r[1]) begin
                C_next = 1'b1;
            end else if (r[2]) begin
                D_next = 1'b1;
            end else begin
                A_next = 1'b1;
            end
        end else if (B) begin
            if (r[0])
                B_next = 1'b1;
            else
                A_next = 1'b1;
        end else if (C) begin
            if (r[1])
                C_next = 1'b1;
            else
                A_next = 1'b1;
        end else if (D) begin
            if (r[2])
                D_next = 1'b1;
            else
                A_next = 1'b1;
        end else begin
            // Safety fallback
            A_next = 1'b1;
        end
    end

    // Output logic: grant signals based on current one-hot state
    always @(*) begin
        g = 3'b000;
        if (B)
            g = 3'b001; // grant device 0
        else if (C)
            g = 3'b010; // grant device 1
        else if (D)
            g = 3'b100; // grant device 2
    end

endmodule