module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;

localparam IDLE = 2'b01;
localparam TAKEN = 2'b10;
localparam MAX = 2'b11;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state_reg <= IDLE;
    end else begin
        case (state_reg)
            IDLE: 
                if (train_valid && train_taken) begin
                    state_reg <= TAKEN;
                end else if (train_valid && !train_taken) begin
                    state_reg <= 2'b00;
                end
            TAKEN: 
                if (train_valid && train_taken) begin
                    state_reg <= MAX;
                end else if (train_valid && !train_taken) begin
                    state_reg <= IDLE;
                end
            MAX: 
                if (train_valid && !train_taken) begin
                    state_reg <= TAKEN;
                end
            2'b00: 
                if (train_valid && train_taken) begin
                    state_reg <= IDLE;
                end
            default: state_reg <= state_reg;
        endcase
    end
end

assign state = state_reg;

endmodule