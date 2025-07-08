module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    // State encoding
    typedef enum logic [2:0] {
        A = 3'd0,  // initial state, waiting for reset release
        B = 3'd1,  // output f=1 one cycle
        C = 3'd2,  // monitoring x sequence 1,0,1
        D = 3'd3,  // g=1, monitor y for 2 cycles
        E = 3'd4,  // g=1 permanent
        F = 3'd5   // g=0 permanent
    } state_t;

    state_t state, next_state;

    // For sequence detection in state C: track progress in sequence 1,0,1
    // Use a 2-bit counter: 0=waiting for 1, 1=got first 1, waiting for 0, 2=got 1,0 waiting for 1
    reg [1:0] seq_pos;

    // For counting y wait cycles in state D
    reg [1:0] y_cnt;

    // State transition and outputs
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            seq_pos <= 0;
            y_cnt <= 0;
            f <= 0;
            g <= 0;
        end else begin
            state <= next_state;
            case (next_state)
                A: begin
                    f <= 0;
                    g <= 0;
                    seq_pos <= 0;
                    y_cnt <= 0;
                end
                B: begin
                    f <= 1;
                    g <= 0;
                    seq_pos <= 0;
                    y_cnt <= 0;
                end
                C: begin
                    f <= 0;
                    g <= 0;
                    y_cnt <= 0;
                    // Update sequence position for x sequence detection
                    // sequence = 1,0,1 in three successive cycles
                    // seq_pos meaning:
                    // 0 = waiting for first 1
                    // 1 = got 1, waiting for 0
                    // 2 = got 1,0 waiting for 1
                    case (seq_pos)
                        0: seq_pos <= (x == 1) ? 1 : 0;
                        1: seq_pos <= (x == 0) ? 2 : ((x==1) ? 1 : 0);
                        2: seq_pos <= (x == 1) ? 3 : ((x==1) ? 1 : 0); // 3 means full sequence matched
                        default: seq_pos <= 0; // reset if invalid
                    endcase
                end
                D: begin
                    f <= 0;
                    g <= 1;
                    // y_cnt counts how many cycles have passed since entering D (max 2)
                    if (y == 1) begin
                        y_cnt <= 0; // no more counting needed
                    end else if (y_cnt < 2) begin
                        y_cnt <= y_cnt + 1;
                    end
                end
                E: begin
                    f <= 0;
                    g <= 1;
                    y_cnt <= 0;
                    seq_pos <= 0;
                end
                F: begin
                    f <= 0;
                    g <= 0;
                    y_cnt <= 0;
                    seq_pos <= 0;
                end
                default: begin
                    f <= 0;
                    g <= 0;
                    seq_pos <= 0;
                    y_cnt <= 0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            A: begin
                if (resetn)
                    next_state = B;
            end
            B: begin
                // After outputting f=1 one cycle, go to C
                next_state = C;
            end
            C: begin
                // Wait until sequence 1,0,1 detected
                if (seq_pos == 3)
                    next_state = D;
                else
                    next_state = C;
            end
            D: begin
                if (y == 1) begin
                    next_state = E; // maintain g=1 permanently
                end else if (y_cnt == 2) begin
                    next_state = F; // g=0 permanently
                end else begin
                    next_state = D;
                end
            end
            E: begin
                // stay until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = E;
            end
            F: begin
                // stay until reset
                if (!resetn)
                    next_state = A;
                else
                    next_state = F;
            end
            default: next_state = A;
        endcase
    end

endmodule