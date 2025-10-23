module TopModule (
    input clk,
    input areset,
    input predict_valid,
    input predict_taken,
    input train_mispredicted,
    input train_taken,
    input [31:0] train_history,
    output [31:0] predict_history
);

    reg [31:0] history_reg;
    reg [4:0] head_ptr;  // Circular buffer head pointer
    wire update_enable = areset || train_mispredicted || predict_valid;
    wire gated_clk = update_enable ? clk : 1'b0;

    always @(posedge gated_clk or posedge areset) begin
        if (areset) begin
            history_reg <= 32'b0;
            head_ptr <= 5'b0;
        end else begin
            case ({train_mispredicted, predict_valid})
                2'b10: begin  // Misprediction takes priority
                    history_reg <= {train_history[30:0], train_taken};
                    head_ptr <= 5'b0;
                end
                2'b01: begin  // Normal prediction
                    history_reg[head_ptr] <= predict_taken;
                    head_ptr <= head_ptr + 1;
                end
                default: ;  // No update
            endcase
        end
    end

    // Circular buffer to linear output conversion
    assign predict_history = {
        history_reg[head_ptr-1],
        history_reg[head_ptr-2],
        history_reg[head_ptr-3],
        history_reg[head_ptr-4],
        history_reg[head_ptr-5],
        history_reg[head_ptr-6],
        history_reg[head_ptr-7],
        history_reg[head_ptr-8],
        history_reg[head_ptr-9],
        history_reg[head_ptr-10],
        history_reg[head_ptr-11],
        history_reg[head_ptr-12],
        history_reg[head_ptr-13],
        history_reg[head_ptr-14],
        history_reg[head_ptr-15],
        history_reg[head_ptr-16],
        history_reg[head_ptr-17],
        history_reg[head_ptr-18],
        history_reg[head_ptr-19],
        history_reg[head_ptr-20],
        history_reg[head_ptr-21],
        history_reg[head_ptr-22],
        history_reg[head_ptr-23],
        history_reg[head_ptr-24],
        history_reg[head_ptr-25],
        history_reg[head_ptr-26],
        history_reg[head_ptr-27],
        history_reg[head_ptr-28],
        history_reg[head_ptr-29],
        history_reg[head_ptr-30],
        history_reg[head_ptr-31],
        history_reg[head_ptr-32]
    };

endmodule