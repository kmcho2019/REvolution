module TopModule(clk, resetn, x, y, f, g);
    input clk, resetn, x, y;
    output f, g;
    reg f, g;
    reg [1:0] x_prev; // to store previous two values of x
    reg [1:0] y_count; // to count clock cycles since g = 1
    reg [2:0] state; // to store current state of FSM

    // define states
    parameter A = 3'b000; // initial state
    parameter B = 3'b001; // set f = 1 for one clock cycle
    parameter C = 3'b010; // monitor x for sequence 1, 0, 1
    parameter D = 3'b011; // set g = 1 and monitor y
    parameter E = 3'b100; // maintain g = 1 permanently
    parameter F = 3'b101; // set g = 0 permanently

    always @(posedge clk) begin
        if (!resetn) begin // reset
            state <= A;
            f <= 0;
            g <= 0;
            x_prev <= 2'b00;
            y_count <= 2'b00;
        end else begin
            case (state)
                A: begin
                    if (resetn) begin
                        state <= B;
                    end
                end
                B: begin
                    f <= 1;
                    state <= C;
                end
                C: begin
                    x_prev <= {x_prev[0], x};
                    if (x_prev == 2'b101) begin // sequence 1, 0, 1 detected
                        state <= D;
                        f <= 0;
                    end
                end
                D: begin
                    g <= 1;
                    y_count <= y_count + 1;
                    if (y) begin
                        state <= E;
                    end else if (y_count == 2) begin
                        state <= F;
                    end
                end
                E: begin // maintain g = 1 permanently
                    g <= 1;
                end
                F: begin // set g = 0 permanently
                    g <= 0;
                end
                default: begin
                    state <= A;
                end
            endcase
        end
    end
endmodule