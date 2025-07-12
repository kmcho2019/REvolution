module PosEdgeFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module NegEdgeFF (
    input clk,
    input d,
    output reg q
);
    always @(negedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input clk,
    input d,
    output reg q
);

    wire q_posedge, q_negedge;

    PosEdgeFF pos_ff (
        .clk(clk),
        .d(d),
        .q(q_posedge)
    );

    NegEdgeFF neg_ff (
        .clk(clk),
        .d(d),
        .q(q_negedge)
    );

    // Register output to reduce glitches and improve timing
    reg clk_d; // delayed clk for edge detection

    always @(posedge clk or negedge clk) begin
        clk_d <= clk;
    end

    always @(posedge clk or negedge clk) begin
        if (clk && !clk_d) begin
            // rising edge detected
            q <= q_posedge;
        end else if (!clk && clk_d) begin
            // falling edge detected
            q <= q_negedge;
        end
    end

endmodule