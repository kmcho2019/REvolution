module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// States for sequence detection
enum logic [1:0] {IDLE, WAIT_0, WAIT_1} state;

// Flag to wait for y
reg wait_y;

// Counter for waiting for y
reg [1:0] y_count;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= IDLE;
        wait_y <= 1'b0;
        y_count <= 0;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (x) state <= WAIT_0;
            end
            WAIT_0: begin
                if (!x) state <= WAIT_1;
                else state <= IDLE;
            end
            WAIT_1: begin
                if (x) begin
                    state <= IDLE;
                    f <= 1;
                    wait_y <= 1'b1;
                    y_count <= 0;
                end else state <= IDLE;
            end
        endcase

        // Set f for one cycle after sequence detection
        if (!wait_y) f <= 0;

        // Wait for y after f has been set
        if (wait_y) begin
            if (y) begin
                g <= 1; // Set g permanently if y is seen
                wait_y <= 1'b0; // Exit wait_y state
            end else if (y_count < 2) begin
                y_count <= y_count + 1; // Increment count
            end else begin
                g <= 0; // Set g to 0 if y not seen within 2 cycles
                wait_y <= 1'b0; // Exit wait_y state
            end
        end
    end
end

endmodule