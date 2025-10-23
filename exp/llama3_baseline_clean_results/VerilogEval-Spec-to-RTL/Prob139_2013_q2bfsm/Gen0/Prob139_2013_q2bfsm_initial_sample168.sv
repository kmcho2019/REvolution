module TopModule(clk, resetn, x, y, f, g);
    input clk, resetn, x, y;
    output f, g;

    reg [2:0] state;  // State register
    reg [1:0] x_count;  // Counter for x input
    reg [1:0] y_count;  // Counter for y input

    // Define states
    parameter A = 3'b000;  // Initial state
    parameter B = 3'b001;  // State after reset
    parameter C = 3'b010;  // Monitor x input
    parameter D = 3'b011;  // Monitor y input
    parameter E = 3'b100;  // g = 1 permanently
    parameter F = 3'b101;  // g = 0 permanently

    always @(posedge clk or negedge resetn) begin
        if (~resetn) begin  // Reset condition
            state <= A;
            x_count <= 0;
            y_count <= 0;
        end else begin
            case (state)
                A: begin  // Initial state
                    if (resetn) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
                B: begin  // State after reset
                    state <= C;
                end
                C: begin  // Monitor x input
                    if (x_count == 0 && x) begin
                        x_count <= x_count + 1;
                    end else if (x_count == 1 && ~x) begin
                        x_count <= x_count + 1;
                    end else if (x_count == 2 && x) begin
                        state <= D;
                        x_count <= 0;
                    end else if (x_count == 1 && x) begin
                        x_count <= 1;
                    end else if (x_count == 2 && ~x) begin
                        x_count <= 0;
                    end else if (x_count == 0 && ~x) begin
                        x_count <= 0;
                    end
                end
                D: begin  // Monitor y input
                    if (y) begin
                        state <= E;
                    end else if (y_count == 1) begin
                        state <= F;
                    end else begin
                        y_count <= y_count + 1;
                    end
                end
                E: begin  // g = 1 permanently
                    state <= E;
                end
                F: begin  // g = 0 permanently
                    state <= F;
                end
            endcase
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            A: begin
                f <= 0;
                g <= 0;
            end
            B: begin
                f <= 1;
                g <= 0;
            end
            C: begin
                f <= 0;
                g <= 0;
            end
            D: begin
                f <= 0;
                g <= 1;
            end
            E: begin
                f <= 0;
                g <= 1;
            end
            F: begin
                f <= 0;
                g <= 0;
            end
        endcase
    end
endmodule