module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

    // Enumerate the states
    localparam A = 0, B = 1, C = 2, D = 3, E = 4, F = 5;
    reg [2:0] state;
    reg [2:0] nextState;

    // Counter for x sequence and y delay
    reg [1:0] x_counter;
    reg [1:0] y_counter;

    always @(posedge clk) begin
        if (~resetn) begin
            state <= A;
            x_counter <= 0;
            y_counter <= 0;
        end else begin
            state <= nextState;
            case (state)
                B: begin
                    x_counter <= 0;
                    y_counter <= 0;
                end
                C: begin
                    if (x == 1 && x_counter == 0) x_counter <= x_counter + 1;
                    else if (x == 0 && x_counter == 1) x_counter <= x_counter + 1;
                    else if (x == 1 && x_counter == 2) x_counter <= 0;
                    else x_counter <= 0;
                end
                D: begin
                    y_counter <= y_counter + 1;
                end
                E: ;
                F: ;
                default: ;
            endcase
        end
    end

    always @(*) begin
        case (state)
            A: begin
                if (~resetn) begin
                    f = 0;
                    g = 0;
                    nextState = A;
                end else begin
                    f = 0;
                    g = 0;
                    nextState = B;
                end
            end
            B: begin
                f = 1;
                g = 0;
                nextState = C;
            end
            C: begin
                f = 0;
                if (x_counter == 3) begin
                    g = 0;
                    nextState = D;
                end else begin
                    g = 0;
                    nextState = C;
                end
            end
            D: begin
                f = 0;
                g = 1;
                if (y == 1 || y_counter == 2) begin
                    if (y == 1) begin
                        nextState = E;
                    end else begin
                        nextState = F;
                    end
                end else begin
                    nextState = D;
                end
            end
            E: begin
                f = 0;
                g = 1;
                nextState = E;
            end
            F: begin
                f = 0;
                g = 0;
                nextState = F;
            end
            default: begin
                f = 0;
                g = 0;
                nextState = A;
            end
        endcase
    end

endmodule