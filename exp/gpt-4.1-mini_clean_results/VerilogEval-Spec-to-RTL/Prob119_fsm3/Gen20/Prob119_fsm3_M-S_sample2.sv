module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    reg [1:0] state;

    always @* begin
        case (state)
            2'b00: state = in ? 2'b01 : 2'b00; // A
            2'b01: state = in ? 2'b01 : 2'b10; // B
            2'b10: state = in ? 2'b11 : 2'b00; // C
            2'b11: state = in ? 2'b01 : 2'b10; // D
            default: state = 2'b00;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // reset to A
        else
            state <= state;
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;
        else
            out <= (state == 2'b11); // out=1 only in state D
    end

endmodule