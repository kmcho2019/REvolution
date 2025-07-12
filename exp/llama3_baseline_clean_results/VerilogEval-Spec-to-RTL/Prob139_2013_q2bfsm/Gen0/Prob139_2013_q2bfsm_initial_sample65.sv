module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define the states
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;
localparam G = 3'b110;

reg [2:0] state, next_state;

// Counter to detect the sequence 1, 0, 1 in the x input
reg [1:0] x_counter;
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        x_counter <= 2'b00;
    end else if (state == C) begin
        case (x_counter)
            2'b00: x_counter <= x ? 2'b01 : 2'b00;
            2'b01: x_counter <= x ? 2'b00 : 2'b10;
            2'b10: x_counter <= x ? 2'b11 : 2'b00;
            default: x_counter <= 2'b00;
        endcase
    end else begin
        x_counter <= 2'b00;
    end
end

// Counter to monitor the y input for at most two clock cycles
reg [1:0] y_counter;
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        y_counter <= 2'b00;
    end else if (state == E) begin
        if (y) begin
            y_counter <= 2'b00;
        end else begin
            y_counter <= y_counter + 1'b1;
        end
    end else begin
        y_counter <= 2'b00;
    end
end

// Next state logic
always @(*) begin
    case (state)
        A: next_state = ~resetn ? B : A;
        B: next_state = C;
        C: next_state = (x_counter == 2'b11) ? D : C;
        D: next_state = E;
        E: next_state = (y || y_counter == 2'b10) ? (y ? F : G) : E;
        F: next_state = F;
        G: next_state = G;
        default: next_state = A;
    endcase
end

// Output logic
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            B: f <= 1;
            default: f <= 0;
        endcase
        case (state)
            D, E, F: g <= 1;
            default: g <= 0;
        endcase
    end
end

endmodule