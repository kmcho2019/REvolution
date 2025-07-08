module TopModule (
    input clk,
    input d,
    output reg q
);

    wire clk_bar;
    reg q_posedge;
    reg q_negedge;

    // Generate inverted clock
    assign clk_bar = ~clk;

    // Flip-flop triggered on rising edge of clk
    always @(posedge clk) begin
        q_posedge <= d;
    end

    // Flip-flop triggered on rising edge of clk_bar (which is falling edge of clk)
    always @(posedge clk_bar) begin
        q_negedge <= d;
    end

    // Select output based on clk value:
    // When clk=1, last edge was rising edge, so output q_posedge
    // When clk=0, last edge was falling edge, so output q_negedge
    always @(*) begin
        if (clk)
            q = q_posedge;
        else
            q = q_negedge;
    end

endmodule