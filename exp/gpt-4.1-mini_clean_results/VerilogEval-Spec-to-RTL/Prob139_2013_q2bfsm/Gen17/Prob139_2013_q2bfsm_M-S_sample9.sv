module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    typedef enum reg [2:0] {
        A = 3'd0, // reset state
        B = 3'd1, // f=1 pulse
        C = 3'd2, // monitor x pattern
        D = 3'd3, // g=1 pulse
        E = 3'd4, // g=1 hold, monitor y
        F = 3'd5, // g=1 permanent
        G = 3'd6  // g=0 permanent
    } state_t;

    reg [2:0] state;
    reg [2:0] x_shift;   // shift register for x inputs
    reg [1:0] y_count;   // counts cycles in state E monitoring y

    always @(posedge clk) begin
        if (!resetn) begin
            state    <= A;
            x_shift  <= 3'b000;
            y_count  <= 2'd0;
            f        <= 1'b0;
            g        <= 1'b0;
        end else begin
            case (state)
                A: begin
                    // Stay here until resetn released, outputs zero
                    f       <= 1'b0;
                    g       <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                    if (resetn)
                        state <= B;
                    else
                        state <= A;
                end

                B: begin
                    // Output f=1 pulse for 1 cycle
                    f       <= 1'b1;
                    g       <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                    state   <= C;
                end

                C: begin
                    // f=0, g=0, shift in x and monitor pattern
                    f       <= 1'b0;
                    g       <= 1'b0;
                    x_shift <= {x_shift[1:0], x};
                    y_count <= 2'd0;
                    if ({x_shift[1:0], x} == 3'b101)
                        state <= D;
                    else
                        state <= C;
                end

                D: begin
                    // g=1 pulse for 1 cycle
                    f       <= 1'b0;
                    g       <= 1'b1;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                    state   <= E;
                end

                E: begin
                    // Hold g=1, monitor y input for max 2 cycles
                    f <= 1'b0;
                    g <= 1'b1;
                    x_shift <= 3'b000;
                    if (y == 1'b1) begin
                        y_count <= 2'd0;
                        state <= F;  // permanent g=1
                    end else if (y_count == 2'd1) begin
                        // After 2 cycles (counting from 0), no y=1 seen
                        y_count <= y_count + 1;
                        state <= G;  // permanent g=0
                    end else begin
                        y_count <= y_count + 1;
                        state <= E;
                    end
                end

                F: begin
                    // g=1 permanent
                    f       <= 1'b0;
                    g       <= 1'b1;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                    state   <= F;
                end

                G: begin
                    // g=0 permanent
                    f       <= 1'b0;
                    g       <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                    state   <= G;
                end

                default: begin
                    // default fallback
                    state   <= A;
                    f       <= 1'b0;
                    g       <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end
            endcase
        end
    end

endmodule