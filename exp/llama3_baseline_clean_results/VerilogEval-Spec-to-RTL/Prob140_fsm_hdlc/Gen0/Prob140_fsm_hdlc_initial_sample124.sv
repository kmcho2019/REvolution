module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

// Define the states
parameter IDLE = 3'b000;
parameter COUNT_1 = 3'b001;
parameter COUNT_2 = 3'b010;
parameter COUNT_3 = 3'b011;
parameter COUNT_4 = 3'b100;
parameter COUNT_5 = 3'b101;
parameter CHECK_FLAG = 3'b110;
parameter ERROR = 3'b111;

// State variable
reg [2:0] state;
reg [2:0] next_state;

// Output signals
reg disc_reg;
reg flag_reg;
reg err_reg;

assign disc = disc_reg;
assign flag = flag_reg;
assign err = err_reg;

// Combinational logic to determine the next state
always @(*) begin
    case (state)
        IDLE: begin
            if (in) begin
                next_state = COUNT_1;
            end else begin
                next_state = IDLE;
            end
        end
        COUNT_1: begin
            if (in) begin
                next_state = COUNT_2;
            end else begin
                next_state = IDLE;
            end
        end
        COUNT_2: begin
            if (in) begin
                next_state = COUNT_3;
            end else begin
                next_state = IDLE;
            end
        end
        COUNT_3: begin
            if (in) begin
                next_state = COUNT_4;
            end else begin
                next_state = IDLE;
            end
        end
        COUNT_4: begin
            if (in) begin
                next_state = COUNT_5;
            end else begin
                next_state = IDLE;
            end
        end
        COUNT_5: begin
            if (in) begin
                next_state = CHECK_FLAG;
            end else begin
                next_state = IDLE;
            end
        end
        CHECK_FLAG: begin
            if (in) begin
                next_state = ERROR;
            end else begin
                next_state = IDLE;
                disc_reg = 1'b1;
            end
        end
        ERROR: begin
            if (~in) begin
                next_state = IDLE;
            end else begin
                next_state = ERROR;
            end
        end
        default: next_state = IDLE;
    endcase

    // Set output signals
    case (state)
        IDLE: begin
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        CHECK_FLAG: begin
            flag_reg = 1'b1;
            disc_reg = 1'b0;
            err_reg = 1'b0;
        end
        ERROR: begin
            err_reg = 1'b1;
            disc_reg = 1'b0;
            flag_reg = 1'b0;
        end
        default: begin
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
    endcase
end

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        disc_reg <= 1'b0;
        flag_reg <= 1'b0;
        err_reg <= 1'b0;
    end else begin
        state <= next_state;
    end
end

endmodule