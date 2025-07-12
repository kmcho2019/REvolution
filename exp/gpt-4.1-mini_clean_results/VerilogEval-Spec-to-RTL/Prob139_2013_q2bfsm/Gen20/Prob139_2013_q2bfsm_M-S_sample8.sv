module TopModule (
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // State encoding
    localparam [2:0]
        A = 3'd0, // reset state
        B = 3'd1, // f=1 pulse
        C = 3'd2, // monitor x pattern 1,0,1
        D = 3'd3, // g=1 pulse
        E = 3'd4, // g=1 hold, monitor y up to 2 cycles
        F = 3'd5, // g=1 permanent
        G = 3'd6; // g=0 permanent

    reg [2:0] state;
    reg [2:0] x_shift;
    reg [1:0] y_count;

    always @(posedge clk) begin
        if (!resetn) begin
            // While reset asserted (active low), stay in A
            state   <= A;
            f       <= 1'b0;
            g       <= 1'b0;
            x_shift <= 3'b000;
            y_count <= 2'd0;
        end else begin
            case(state)
                A: begin
                    // On release of reset, move to B (f=1 pulse)
                    state <= B;
                    f     <= 1'b1;
                    g     <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end

                B: begin
                    // One cycle pulse f=1 done, next monitor pattern
                    state <= C;
                    f     <= 1'b0;
                    g     <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end

                C: begin
                    // Shift in x and check for pattern 1,0,1
                    x_shift <= {x_shift[1:0], x};
                    f       <= 1'b0;
                    g       <= 1'b0;
                    y_count <= 2'd0;
                    // After shifting, check pattern
                    if ({x_shift[1:0], x} == 3'b101)
                        state <= D;
                    else
                        state <= C;
                end

                D: begin
                    // g=1 pulse for one cycle
                    state <= E;
                    f     <= 1'b0;
                    g     <= 1'b1;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end

                E: begin
                    // Hold g=1, monitor y for up to 2 cycles
                    f <= 1'b0;
                    g <= 1'b1;

                    if (y == 1'b1) begin
                        // y=1 within two cycles: g=1 permanent
                        state <= F;
                        y_count <= 2'd0;
                    end else if (y_count == 2'd1) begin
                        // y !=1 in two cycles: g=0 permanent
                        state <= G;
                        y_count <= 2'd0;
                    end else begin
                        // Increment count and stay in E
                        y_count <= y_count + 1'b1;
                        state <= E;
                    end
                    x_shift <= 3'b000;
                end

                F: begin
                    // g=1 permanent
                    f <= 1'b0;
                    g <= 1'b1;
                    state <= F;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end

                G: begin
                    // g=0 permanent
                    f <= 1'b0;
                    g <= 1'b0;
                    state <= G;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end

                default: begin
                    // Safety fallback to reset state
                    state <= A;
                    f <= 1'b0;
                    g <= 1'b0;
                    x_shift <= 3'b000;
                    y_count <= 2'd0;
                end
            endcase
        end
    end

endmodule