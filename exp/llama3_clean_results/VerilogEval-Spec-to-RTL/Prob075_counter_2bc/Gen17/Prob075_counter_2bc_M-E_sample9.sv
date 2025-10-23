module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;
reg [1:0] next_state;

localparam IDLE = 2'b01;
localparam COUNT1 = 2'b01;
localparam COUNT2 = 2'b10;
localparam COUNT3 = 2'b11;

always @(*) begin
    case (state_reg)
        IDLE: begin
            if (train_valid) begin
                if (train_taken) begin
                    next_state = COUNT2;
                end else begin
                    next_state = IDLE; // saturate at IDLE
                end
            end else begin
                next_state = IDLE;
            end
        end
        COUNT1: begin
            if (train_valid) begin
                if (train_taken) begin
                    next_state = COUNT3;
                end else begin
                    next_state = IDLE;
                end
            end else begin
                next_state = COUNT1;
            end
        end
        COUNT2: begin
            if (train_valid) begin
                if (train_taken) begin
                    next_state = COUNT3;
                end else begin
                    next_state = COUNT1;
                end
            end else begin
                next_state = COUNT2;
            end
        end
        COUNT3: begin
            if (train_valid) begin
                if (train_taken) begin
                    next_state = COUNT3; // saturate at COUNT3
                end else begin
                    next_state = COUNT2;
                end
            end else begin
                next_state = COUNT3;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state_reg <= IDLE;
    end else begin
        state_reg <= next_state;
    end
end

assign state = state_reg;

endmodule