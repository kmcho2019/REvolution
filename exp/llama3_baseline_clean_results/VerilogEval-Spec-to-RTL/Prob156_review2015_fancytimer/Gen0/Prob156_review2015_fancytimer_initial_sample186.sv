module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [3:0] delay;
reg [3:0] current_count;
reg [9:0] total_count;
reg [3:0] pattern_register;
reg counting_reg;
reg done_reg;
reg [1:0] state;
reg [1:0] next_state;

// State encoding
localparam IDLE = 2'b00;
localparam GET_DELAY = 2'b01;
localparam COUNTING = 2'b10;
localparam DONE = 2'b11;

// Counting output
assign counting = counting_reg;

// Done output
assign done = done_reg;

// Count output
assign count = current_count;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        counting_reg <= 1'b0;
        done_reg <= 1'b0;
        current_count <= 4'b0;
        total_count <= 10'b0;
        pattern_register <= 4'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (pattern_register == 4'b1101) begin
                    state <= GET_DELAY;
                end
                else if (data == 1'b1) begin
                    pattern_register <= {pattern_register[2:0], 1'b1};
                end
                else begin
                    pattern_register <= {pattern_register[2:0], 1'b0};
                end
            end
            GET_DELAY: begin
                delay <= {delay[2:0], data};
                if (delay[3] == 1'b0) begin
                    state <= COUNTING;
                    total_count <= (delay + 1'b1) * 10'b1000;
                    current_count <= delay;
                    counting_reg <= 1'b1;
                end
            end
            COUNTING: begin
                if (total_count == 10'b0) begin
                    state <= DONE;
                    done_reg <= 1'b1;
                    counting_reg <= 1'b0;
                end
                else begin
                    total_count <= total_count - 10'b1;
                    if (total_count[0] == 1'b0) begin
                        current_count <= current_count - 1'b1;
                    end
                end
            end
            DONE: begin
                if (ack == 1'b1) begin
                    state <= IDLE;
                    done_reg <= 1'b0;
                    current_count <= 4'b0;
                    total_count <= 10'b0;
                    pattern_register <= 4'b0;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end

endmodule