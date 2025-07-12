module TopModule(
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

reg [2:0] state; // 3 bits to represent 8 states using binary encoding
reg [2:0] count; // Counter for consecutive ones

// Define the states using binary encoding
localparam IDLE = 3'b000;
localparam COUNTING = 3'b001;
localparam FLAG = 3'b010;
localparam ERROR = 3'b011;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        count <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (in) begin
                    state <= COUNTING;
                    count <= 1;
                end else begin
                    state <= IDLE;
                end
            end
            COUNTING: begin
                if (in) begin
                    count <= count + 1;
                    if (count == 5) begin
                        state <= COUNTING;
                    end else if (count == 6) begin
                        if (in) begin
                            state <= ERROR;
                        end else begin
                            state <= FLAG;
                        end
                    end
                end else begin
                    if (count == 5) begin
                        disc <= 1;
                        state <= IDLE;
                    end else begin
                        state <= IDLE;
                    end
                    count <= 0;
                end
            end
            FLAG: begin
                flag <= 1;
                state <= IDLE;
                count <= 0;
            end
            ERROR: begin
                err <= 1;
                state <= IDLE;
                count <= 0;
            end
        endcase
    end
end

assign disc = (state == COUNTING && count == 5) ? 1 : 0;
assign flag = (state == FLAG) ? 1 : 0;
assign err = (state == ERROR) ? 1 : 0;

endmodule