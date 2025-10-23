module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // 3-bit state variable to represent states A, B, C, D, E, F
reg [1:0] x_count; // counter to monitor x sequence
reg [1:0] y_count; // counter to monitor y

// state definitions
localparam A = 3'b000; // beginning state
localparam B = 3'b001; // state after reset de-assertion
localparam C = 3'b010; // state where f is high
localparam D = 3'b011; // state where x is being monitored
localparam E = 3'b100; // state where g is high and y is being monitored
localparam F = 3'b101; // state where g is permanently high or low based on y

always @(posedge clk) begin
    if (!resetn) begin // reset
        state <= A;
        f <= 0;
        g <= 0;
        x_count <= 0;
        y_count <= 0;
    end else begin
        case (state)
            A: begin
                state <= B;
                f <= 1;
            end
            B: begin
                state <= C;
                f <= 0;
            end
            C: begin
                if (x) begin
                    x_count <= x_count + 1;
                    if (x_count == 3'b001) begin
                        state <= D;
                    end
                end else begin
                    x_count <= 0;
                end
            end
            D: begin
                if (x == 0) begin
                    x_count <= x_count + 1;
                    if (x_count == 3'b010) begin
                        state <= E;
                        g <= 1;
                    end
                end else if (x == 1) begin
                    x_count <= 0;
                    state <= C;
                end
            end
            E: begin
                y_count <= y_count + 1;
                if (y) begin
                    state <= F;
                end else if (y_count == 2'b10) begin
                    state <= F;
                    g <= 0;
                end
            end
            F: begin
                // stay in this state
            end
            default: begin
                state <= A;
            end
        endcase
    end
end

endmodule