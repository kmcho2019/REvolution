module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

// State encoding
localparam IDLE = 2'b00;
localparam ACCUM_1 = 2'b01;
localparam ACCUM_2 = 2'b10;
localparam ACCUM_3 = 2'b11;

reg [1:0] state, next_state;
reg [9:0] accum_reg;

// State transition logic
always @(*) begin
    next_state = state;
    case (state)
        IDLE: if (valid_in) next_state = ACCUM_1;
        ACCUM_1: if (valid_in) next_state = ACCUM_2;
        ACCUM_2: if (valid_in) next_state = ACCUM_3;
        ACCUM_3: if (valid_in) next_state = IDLE;
    endcase
end

// Sequential logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        accum_reg <= 10'b0;
        data_out <= 10'b0;
    end
    else begin
        state <= next_state;
        
        // Accumulation logic
        if (valid_in) begin
            case (state)
                IDLE: accum_reg <= data_in;
                ACCUM_1: accum_reg <= accum_reg + data_in;
                ACCUM_2: accum_reg <= accum_reg + data_in;
                ACCUM_3: begin
                    data_out <= accum_reg + data_in;
                    accum_reg <= 10'b0;
                end
            endcase
        end
    end
end

// Output logic
assign valid_out = (state == ACCUM_3) && valid_in;

endmodule