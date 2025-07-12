module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Enum for states
enum logic [2:0] {
    A, // Reset state
    SET_F, // State to set f to 1
    WAIT_X1, // Wait for first 1 in x sequence
    WAIT_X0, // Wait for 0 in x sequence
    WAIT_X2, // Wait for second 1 in x sequence
    SET_G, // Set g to 1
    WAIT_Y // Wait for y to become 1 within two clock cycles
} state, next_state;

// Counter to keep track of clock cycles for y
reg [1:0] y_counter;

always @(posedge clk) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            A: begin
                next_state <= SET_F;
                f <= 0;
                g <= 0;
            end
            SET_F: begin
                next_state <= WAIT_X1;
                f <= 1;
                g <= 0;
            end
            WAIT_X1: begin
                if (x) begin
                    next_state <= WAIT_X0;
                end else begin
                    next_state <= WAIT_X1;
                end
                f <= 0;
                g <= 0;
            end
            WAIT_X0: begin
                if (~x) begin
                    next_state <= WAIT_X2;
                end else begin
                    next_state <= WAIT_X1;
                end
                f <= 0;
                g <= 0;
            end
            WAIT_X2: begin
                if (x) begin
                    next_state <= SET_G;
                end else begin
                    next_state <= WAIT_X1;
                end
                f <= 0;
                g <= 0;
            end
            SET_G: begin
                next_state <= WAIT_Y;
                f <= 0;
                g <= 1;
                y_counter <= 2'd0;
            end
            WAIT_Y: begin
                if (y) begin
                    next_state <= SET_G;
                end else if (y_counter == 2'd2) begin
                    next_state <= A;
                    g <= 0;
                end else begin
                    next_state <= WAIT_Y;
                    y_counter <= y_counter + 1;
                end
                f <= 0;
            end
        endcase
    end
end

endmodule