module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

// State encoding
localparam IDLE = 2'b00;
localparam LOAD = 2'b01;
localparam CALC = 2'b10;
localparam DONE = 2'b11;

reg [1:0] state, next_state;
reg [3:0] count;
reg [15:0] areg;
reg [31:0] acc;
wire [31:0] shifted_b;

// Sequential shift calculation
assign shifted_b = bin << count;

// State transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: next_state = start ? LOAD : IDLE;
        LOAD: next_state = CALC;
        CALC: next_state = (count == 15) ? DONE : CALC;
        DONE: next_state = IDLE;
        default: next_state = IDLE;
    endcase
end

// Datapath control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'b0;
        acc <= 32'b0;
        count <= 4'b0;
        yout <= 32'b0;
    end else begin
        case (state)
            IDLE: begin
                areg <= 16'b0;
                acc <= 32'b0;
                count <= 4'b0;
            end
            LOAD: begin
                areg <= ain;
                acc <= 32'b0;
                count <= 4'b0;
            end
            CALC: begin
                if (areg[count]) begin
                    acc <= acc + shifted_b;
                end
                count <= count + 1;
            end
            DONE: begin
                yout <= acc;
            end
        endcase
    end
end

// Output assignments
assign done = (state == DONE);

endmodule