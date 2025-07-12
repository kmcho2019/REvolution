module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State definition
enum logic [2:0] {
    A = 3'b000, // Reset State
    B = 3'b001, // Initial Pulse
    C = 3'b010, // Monitoring X
    D = 3'b011, // Setting G and Monitoring Y
    E = 3'b100, // Permanently High G
    F = 3'b101  // Permanently Low G
} state, nextState;

// Counter for monitoring x sequence
reg [1:0] x_counter;

// Counter for monitoring y within two cycles
reg [1:0] y_counter;

always @(*) begin
    // Default values
    f = 0;
    g = 0;
    nextState = state;

    case(state)
        A: begin
            if (~resetn) begin
                nextState = A;
            end else begin
                nextState = B;
            end
        end
        B: begin
            f = 1;
            nextState = C;
        end
        C: begin
            case(x_counter)
                2'b00: begin
                    if (x) begin
                        x_counter = 2'b01;
                    end
                end
                2'b01: begin
                    if (~x) begin
                        x_counter = 2'b10;
                    end else begin
                        x_counter = 2'b01;
                    end
                end
                2'b10: begin
                    if (x) begin
                        nextState = D;
                        x_counter = 2'b00;
                    end else begin
                        x_counter = 2'b01;
                    end
                end
            endcase
        end
        D: begin
            g = 1;
            if (y) begin
                nextState = E;
            end else if (y_counter == 2'b10) begin
                nextState = F;
            end else begin
                y_counter = y_counter + 1;
            end
        end
        E: begin
            g = 1;
        end
        F: begin
            g = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        x_counter <= 2'b00;
        y_counter <= 2'b00;
    end else begin
        state <= nextState;
    end
end

endmodule