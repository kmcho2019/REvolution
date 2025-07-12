module TopModule(
    input  wire clk,
    input  wire resetn,  // synchronous active low reset
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    // FSM states (3 bits)
    localparam A = 3'd0,
               B = 3'd1,
               C = 3'd2,
               D = 3'd3,
               E = 3'd4,
               F = 3'd5,
               G = 3'd6;

    reg [2:0] state;

    // Shift register for x input to detect pattern 101
    reg [1:0] x_hist; // last two x inputs (new x will form a 3-bit pattern with x_hist)
    // y monitor counter
    reg [1:0] y_count;

    always @(posedge clk) begin
        if (!resetn) begin
            state   <= A;
            f       <= 1'b0;
            g       <= 1'b0;
            x_hist  <= 2'b00;
            y_count <= 2'd0;
        end else begin
            case(state)
                A: begin
                    // Hold outputs low and wait for reset release
                    f <= 1'b0;
                    g <= 1'b0;
                    x_hist <= 2'b00;
                    y_count <= 2'd0;
                    // Move to B after reset release
                    state <= B;
                end

                B: begin
                    // Pulse f=1 for one clock cycle
                    f <= 1'b1;
                    g <= 1'b0;
                    x_hist <= 2'b00;
                    y_count <= 2'd0;
                    state <= C;
                end

                C: begin
                    // Monitor x pattern 101 over three cycles
                    f <= 1'b0;
                    g <= 1'b0;
                    // Update x_hist shift register
                    x_hist <= {x_hist[0], x};
                    // Check if pattern is 101:
                    // pattern bits: {x_hist[1], x_hist[0], x}
                    if ({x_hist, x} == 3'b101) 
                        state <= D;
                    else
                        state <= C;
                    y_count <= 2'd0;
                end

                D: begin
                    // Pulse g=1 for one clock cycle after pattern detection
                    f <= 1'b0;
                    g <= 1'b1;
                    x_hist <= 2'b00;
                    y_count <= 2'd0;
                    state <= E;
                end

                E: begin
                    // Maintain g=1 and monitor y input for up to 2 cycles
                    f <= 1'b0;
                    g <= 1'b1;
                    x_hist <= 2'b00;
                    if (y == 1'b1) begin
                        // y=1 detected within allowed time; hold g=1 permanently
                        state <= F;
                        y_count <= 2'd0;
                    end else if (y_count == 2'd1) begin
                        // two cycles passed without y=1; g=0 permanently
                        state <= G;
                        y_count <= 2'd0;
                    end else begin
                        // increment y_count and stay in E
                        y_count <= y_count + 1'b1;
                        state <= E;
                    end
                end

                F: begin
                    // g=1 permanently
                    f <= 1'b0;
                    g <= 1'b1;
                    x_hist <= 2'b00;
                    y_count <= 2'd0;
                    state <= F;
                end

                G: begin
                    // g=0 permanently
                    f <= 1'b0;
                    g <= 1'b0;
                    x_hist <= 2'b00;
                    y_count <= 2'd0;
                    state <= G;
                end

                default: begin
                    // Should not happen: reset to A
                    f <= 1'b0;
                    g <= 1'b0;
                    x_hist <= 2'b00;
                    y_count <= 2'd0;
                    state <= A;
                end
            endcase
        end
    end

endmodule