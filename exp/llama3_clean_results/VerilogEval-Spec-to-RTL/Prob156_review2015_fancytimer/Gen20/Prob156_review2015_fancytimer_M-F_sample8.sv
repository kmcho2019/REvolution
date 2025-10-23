module TopModule(
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

reg [2:0] state; 
reg [3:0] delay;
reg [19:0] counter;
reg [3:0] remaining_time;
reg [3:0] pattern_reg;
reg [3:0] bit_counter;
reg counting_reg;
reg done_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 3'b000; 
        delay <= 0;
        counter <= 0;
        remaining_time <= 0;
        pattern_reg <= 0;
        bit_counter <= 0;
        counting_reg <= 0;
        done_reg <= 0;
    end else begin
        case (state)
            3'b000: begin 
                state <= 3'b001; 
            end
            3'b001: begin 
                pattern_reg <= {pattern_reg[2:0], data};
                if (pattern_reg == 4'b1101) begin
                    state <= 3'b010; 
                end
            end
            3'b010: begin 
                delay <= {data, delay[3:1]};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 4) begin
                    counter <= (delay + 1) * 1000 - 1;
                    remaining_time <= delay;
                    state <= 3'b011; 
                end
            end
            3'b011: begin 
                counter <= counter - 1;
                if (counter % 1000 == 0) begin
                    remaining_time <= remaining_time - 1;
                end
                if (counter == 0) begin
                    state <= 3'b100; 
                end
                counting_reg <= 1;
            end
            3'b100: begin 
                done_reg <= 1;
                if (ack == 1'b1) begin
                    state <= 3'b000; 
                end
                counting_reg <= 0;
            end
        endcase
    end
end

assign count = (state == 3'b011)? remaining_time : 4'bxxxx;
assign counting = (state == 3'b011)? 1'b1 : 1'b0;
assign done = (state == 3'b100)? 1'b1 : 1'b0;

endmodule