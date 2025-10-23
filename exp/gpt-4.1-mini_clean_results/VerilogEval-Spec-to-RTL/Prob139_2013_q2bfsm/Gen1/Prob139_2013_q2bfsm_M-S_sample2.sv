module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

// State encoding (3 bits)
localparam [2:0]
    A = 3'd0, // Reset state
    B = 3'd1, // f=1 one cycle after reset release
    C = 3'd2, // Sequence detection
    D = 3'd3, // g=1, monitor y for 2 cycles
    E = 3'd4, // g=1 permanent (success)
    F = 3'd5; // g=0 permanent (failure)

reg [2:0] state, next_state;

// Sequence progress: counts how many elements of x sequence matched (0 to 3)
// 0 = no match, 1 = matched '1', 2 = matched '1,0', 3 = matched '1,0,1' (complete)
reg [1:0] seq_progress;

// Counter for y monitoring in state D (0 to 2)
reg [1:0] y_cnt;

// Sequential logic: state, seq_progress, y_cnt update
always @(posedge clk) begin
    if (!resetn) begin
        state        <= A;
        seq_progress <= 2'd0;
        y_cnt        <= 2'd0;
    end else begin
        state <= next_state;
        // Update seq_progress only in state C
        if (state == C) begin
            case (seq_progress)
                2'd0: seq_progress <= (x == 1'b1) ? 2'd1 : 2'd0;
                2'd1: seq_progress <= (x == 1'b0) ? 2'd2 :
                                      (x == 1'b1) ? 2'd1 : 2'd0;
                2'd2: seq_progress <= (x == 1'b1) ? 2'd3 : 2'd0;
                default: seq_progress <= 2'd0;
            endcase
        end else begin
            seq_progress <= 2'd0;
        end

        // Update y_cnt only in state D
        if (state == D) begin
            y_cnt <= y_cnt + 1;
        end else begin
            y_cnt <= 2'd0;
        end
    end
end

// Next state logic
always @(*) begin
    next_state = state; // default hold

    case (state)
        A: begin
            if (resetn) next_state = B;
        end

        B: begin
            // f=1 for exactly 1 cycle, then go to sequence detection
            next_state = C;
        end

        C: begin
            // Wait for sequence progress to complete
            if (seq_progress == 2'd3) begin
                // sequence 1,0,1 detected => next state D
                next_state = D;
            end else begin
                next_state = C;
            end
        end

        D: begin
            // g=1, monitor y for up to 2 cycles (y_cnt counts 0,1)
            if (y == 1'b1) begin
                next_state = E; // success: permanent g=1
            end else if (y_cnt == 2'd1) begin
                // After 2 cycles (counting 0 and 1), no y=1 detected
                next_state = F; // failure: permanent g=0
            end else begin
                next_state = D; // keep monitoring
            end
        end

        E: begin
            // Permanent g=1 until reset
            next_state = E;
        end

        F: begin
            // Permanent g=0 until reset
            next_state = F;
        end

        default: next_state = A;
    endcase
end

// Output logic
always @(*) begin
    // Defaults
    f = 1'b0;
    g = 1'b0;

    case (state)
        B: f = 1'b1;
        D: g = 1'b1;
        E: g = 1'b1;
        // F: g = 0 (default)
    endcase
end

endmodule