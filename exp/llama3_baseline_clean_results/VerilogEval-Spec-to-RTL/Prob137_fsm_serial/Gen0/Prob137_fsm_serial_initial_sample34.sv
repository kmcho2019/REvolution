module TopModule(
    input  clk,
    input  reset,
    input  in,
    output done
);

reg [2:0] state;  // Idle, Start, Data, Stop, Error
reg [7:0] counter;  // counter for data bits
reg [7:0] data;    // stored data bits
reg done_reg;      // internal done signal

// Define states
localparam IDLE = 3'b000;
localparam START = 3'b001;
localparam DATA = 3'b010;
localparam STOP = 3'b011;
localparam ERROR = 3'b100;

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        counter <= 8'd0;
        data <= 8'd0;
        done_reg <= 1'b0;
    end else begin
        case(state)
            IDLE: begin
                if(!in) begin
                    state <= START;
                end
            end
            START: begin
                state <= DATA;
            end
            DATA: begin
                data[7 - counter] <= in;
                if(counter == 8'd7) begin
                    state <= STOP;
                end else begin
                    counter <= counter + 1;
                end
            end
            STOP: begin
                if(in) begin
                    done_reg <= 1'b1;
                    state <= IDLE;
                    counter <= 8'd0;
                    data <= 8'd0;
                end else begin
                    state <= ERROR;
                end
            end
            ERROR: begin
                if(in) begin
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

assign done = done_reg;

always @(posedge clk) begin
    if(state == IDLE && !reset) begin
        done_reg <= 1'b0;
    end
end

endmodule