module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state;

// Encoding for states: A = 3'b000, B = 3'b001, C = 3'b010, D = 3'b011, E = 3'b100, F = 3'b101
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            A: begin
                if (resetn) state <= B;
            end
            B: begin
                f <= 1;
                state <= C;
            end
            C: begin
                f <= 0;
                static reg [2:0] x_sequence = 3'b000;
                x_sequence <= {x_sequence[1:0], x};
                if (x_sequence == 3'b101) state <= D;
            end
            D: begin
                g <= 1;
                static reg [1:0] y_counter = 2'b00;
                if (y) state <= E;
                else if (y_counter == 2'b11) state <= F;
                else y_counter <= y_counter + 1'b1;
            end
            E: begin
                // Do nothing, maintain state E and g = 1
            end
            F: begin
                g <= 0;
                // Do nothing, maintain state F and g = 0
            end
            default: state <= A;
        endcase
    end
end

endmodule