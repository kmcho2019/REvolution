module TopModule(
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

// Counter to track the number of consecutive ones
logic [2:0] ones_counter;

// State variable
logic [1:0] state;

// Next state logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= 2'b00;
        ones_counter <= 3'b000;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (in) begin
                    ones_counter <= ones_counter + 1;
                    if (ones_counter == 5) begin
                        state <= 2'b01; // DISCARD state
                    end else if (ones_counter >= 6) begin
                        state <= 2'b10; // FLAG state
                    end else if (ones_counter >= 7) begin
                        state <= 2'b11; // ERR state
                    end
                end else begin
                    ones_counter <= 3'b000;
                end
            end
            2'b01: begin // DISCARD state
                state <= 2'b00;
                ones_counter <= 3'b000;
            end
            2'b10: begin // FLAG state
                state <= 2'b00;
                ones_counter <= 3'b000;
            end
            2'b11: begin // ERR state
                if (~in) begin
                    state <= 2'b00;
                    ones_counter <= 3'b000;
                end
            end
            default: state <= 2'b00;
        endcase
    end
end

// Output logic
always_comb begin
    case (state)
        2'b00: begin // IDLE state
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
        2'b01: begin // DISCARD state
            disc = 1'b1;
            flag = 1'b0;
            err = 1'b0;
        end
        2'b10: begin // FLAG state
            disc = 1'b0;
            flag = 1'b1;
            err = 1'b0;
        end
        2'b11: begin // ERR state
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b1;
        end
        default: begin
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
    endcase
end

endmodule