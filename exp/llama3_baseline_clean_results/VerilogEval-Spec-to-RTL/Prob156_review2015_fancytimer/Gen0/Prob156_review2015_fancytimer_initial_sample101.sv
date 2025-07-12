module TopModule(
    input  clk,
    input  reset,
    input  data,
    output [3:0] count,
    output counting,
    output done,
    input  ack
);

// State register
reg [2:0] state;
reg [2:0] nextState;

// Counter registers
reg [3:0] delay;
reg [9:0] counter; // 10-bit counter to count 1000 clock cycles
reg [3:0] countReg;

// Shift register
reg [3:0] shiftReg;

always @(*)
begin
    case(state)
        3'b000: // Idle state
        begin
            if (data == 1 && shiftReg == 4'b110)
                nextState = 3'b001; // Start shifting
            else if (data == 0 && shiftReg == 4'b1101)
                nextState = 3'b001; // Start shifting
            else
                nextState = 3'b000; // Stay in idle state
        end
        3'b001: // Shift state
        begin
            if (counter == 10'd4)
                nextState = 3'b010; // Start counting
            else
                nextState = 3'b001; // Continue shifting
        end
        3'b010: // Count state
        begin
            if (countReg == 4'd0 && counter == 10'd1000)
                nextState = 3'b011; // Done state
            else if (counter == 10'd1000)
                nextState = 3'b010; // Continue counting
            else
                nextState = 3'b010; // Stay in count state
        end
        3'b011: // Done state
        begin
            if (ack == 1)
                nextState = 3'b000; // Reset to idle state
            else
                nextState = 3'b011; // Stay in done state
        end
        default:
            nextState = 3'b000;
    endcase
end

always @(posedge clk)
begin
    if (reset == 1)
    begin
        state <= 3'b000;
        shiftReg <= 4'b0000;
        delay <= 4'b0000;
        counter <= 10'd0;
        countReg <= 4'b0000;
    end
    else
    begin
        state <= nextState;
        case(state)
            3'b000: // Idle state
            begin
                if (data == 1)
                    shiftReg <= {shiftReg[2:0], 1'b1};
                else if (data == 0)
                    shiftReg <= {shiftReg[2:0], 1'b0};
            end
            3'b001: // Shift state
            begin
                if (data == 1)
                    delay <= {data, delay[3:1]};
                else if (data == 0)
                    delay <= {data, delay[3:1]};
                counter <= counter + 1;
                if (counter == 10'd4)
                    counter <= 10'd0;
            end
            3'b010: // Count state
            begin
                if (counter == 10'd1000)
                begin
                    countReg <= countReg - 1;
                    counter <= 10'd0;
                end
                else
                    counter <= counter + 1;
            end
            3'b011: // Done state
            begin
                // Do nothing
            end
            default:
                // Do nothing
        endcase
    end
end

assign count = (state == 3'b010) ? countReg : 4'bxxxx;
assign counting = (state == 3'b010) ? 1'b1 : 1'b0;
assign done = (state == 3'b011) ? 1'b1 : 1'b0;

endmodule