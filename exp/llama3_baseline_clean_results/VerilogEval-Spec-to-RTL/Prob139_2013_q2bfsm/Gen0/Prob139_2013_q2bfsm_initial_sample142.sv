module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

// Define the states
parameter A = 4'b0000;
parameter B = 4'b0001;
parameter C = 4'b0010;
parameter D = 4'b0011;
parameter E = 4'b0100;
parameter F = 4'b0101;

// Define the current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Define the counter for states C and D
reg [1:0] counter;

// Define the sequence detector for x
reg [1:0] x_seq;

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
        f <= 0;
        g <= 0;
        counter <= 0;
        x_seq <= 0;
    end else begin
        current_state <= next_state;
        case(current_state)
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
end

always @(*) begin
    case(current_state)
        A: begin
            if (resetn) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            next_state = C;
            counter = 0;
            x_seq = 0;
        end
        C: begin
            case(x_seq)
                0: begin
                    if (x) begin
                        x_seq = x_seq + 1;
                    end
                end
                1: begin
                    if (!x) begin
                        x_seq = x_seq + 1;
                    end else begin
                        x_seq = 0;
                    end
                end
                2: begin
                    if (x) begin
                        next_state = D;
                        counter = 0;
                        x_seq = 0;
                    end else begin
                        x_seq = 0;
                    end
                end
            endcase
        end
        D: begin
            counter = counter + 1;
            if (y || counter == 2) begin
                if (y) begin
                    next_state = E;
                end else begin
                    next_state = F;
                end
            end else begin
                next_state = D;
            end
        end
        E: begin
            next_state = E;
        end
        F: begin
            next_state = F;
        end
    endcase
end

endmodule