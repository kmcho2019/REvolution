module LIFObuffer (
    input  wire [3:0] dataIn,
    input  wire       RW,    // 0: write (push), 1: read (pop)
    input  wire       EN,
    input  wire       Rst,
    input  wire       Clk,
    output wire       EMPTY,
    output wire       FULL,
    output reg  [3:0] dataOut
);

    // Stack memory: 4 entries of 4 bits each
    reg [3:0] stack_mem [3:0];

    // One-hot encoded Stack Pointer states: 5 states representing SP = 4 down to 0
    // SP_onehot[4]: SP == 4 (empty)
    // SP_onehot[3:0]: SP values 3 down to 0 indicating top stack index
    reg [4:0] SP_onehot;

    integer i;

    // Convert one-hot SP to integer index (0 to 4)
    // Encoded as:
    // SP_onehot = 5'b1_0000 -> SP=4 (empty)
    // SP_onehot = 5'b0_1000 -> SP=3
    // ...
    // SP_onehot = 5'b0_0001 -> SP=0 (full)
    function [2:0] onehot_to_index;
        input [4:0] oh;
        begin
            // Return index 0-4 where oh[index] is 1
            // If none matched, default 4 (empty)
            if      (oh[0]) onehot_to_index = 3'd0;
            else if (oh[1]) onehot_to_index = 3'd1;
            else if (oh[2]) onehot_to_index = 3'd2;
            else if (oh[3]) onehot_to_index = 3'd3;
            else            onehot_to_index = 3'd4;
        end
    endfunction

    // Derived push and pop enable signals
    wire [2:0] SP_idx = onehot_to_index(SP_onehot);
    wire can_push = EN && (RW == 1'b0) && (SP_idx != 3'd0);
    wire can_pop  = EN && (RW == 1'b1) && (SP_idx != 3'd4);

    // Compute EMPTY and FULL combinationally
    assign EMPTY = SP_onehot[4];   // SP==4 means empty
    assign FULL  = SP_onehot[0];   // SP==0 means full

    // Generate clock enable for registers (only active on push or pop)
    wire CE = can_push || can_pop;

    // Next SP_onehot logic based on push or pop
    reg [4:0] SP_next;
    always @(*) begin
        SP_next = SP_onehot;
        if (can_push) begin
            // push: decrement SP index by 1
            case (SP_onehot)
                5'b1_0000: SP_next = 5'b0_1000; // 4->3
                5'b0_1000: SP_next = 5'b0_0100; // 3->2
                5'b0_0100: SP_next = 5'b0_0010; // 2->1
                5'b0_0010: SP_next = 5'b0_0001; // 1->0
                default:   SP_next = SP_onehot; // no change or full
            endcase
        end else if (can_pop) begin
            // pop: increment SP index by 1
            case (SP_onehot)
                5'b0_0001: SP_next = 5'b0_0010; // 0->1
                5'b0_0010: SP_next = 5'b0_0100; // 1->2
                5'b0_0100: SP_next = 5'b0_1000; // 2->3
                5'b0_1000: SP_next = 5'b1_0000; // 3->4
                default:   SP_next = SP_onehot; // no change or empty
            endcase
        end
        // else no change
    end

    always @(posedge Clk) begin
        if (Rst) begin
            SP_onehot <= 5'b1_0000; // empty state (SP=4)
            dataOut <= 4'd0;
            // Do NOT clear stack_mem to save area and reset time
        end else if (CE) begin
            SP_onehot <= SP_next;

            if (can_push) begin
                // On push: write dataIn to stack_mem at SP_next index (new top)
                // SP_next index is top after decrement, i.e. one less than SP_idx
                // Convert SP_next one-hot to index for addressing stack_mem
                case (SP_next)
                    5'b0_0001: stack_mem[0] <= dataIn;
                    5'b0_0010: stack_mem[1] <= dataIn;
                    5'b0_0100: stack_mem[2] <= dataIn;
                    5'b0_1000: stack_mem[3] <= dataIn;
                    default: ; // do nothing if empty or invalid
                endcase
                // dataOut unchanged on push
            end else if (can_pop) begin
                // On pop: output data from current SP (SP_onehot)
                // SP_onehot points to current top
                case (SP_onehot)
                    5'b0_0001: dataOut <= stack_mem[0];
                    5'b0_0010: dataOut <= stack_mem[1];
                    5'b0_0100: dataOut <= stack_mem[2];
                    5'b0_1000: dataOut <= stack_mem[3];
                    default:   dataOut <= 4'd0; // empty or invalid
                endcase
                // do NOT clear stack_mem to reduce switching
            end
        end
        // else hold registers to reduce switching
    end

endmodule