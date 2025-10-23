module counter(
    input clk,
    input areset,
    input enable,
    output reg [1:0] count
);

always @(posedge clk or posedge areset)
begin
    if(areset)
        count <= 0;
    else if(enable)
        count <= count + 1;
    else
        count <= 0;
end

endmodule

module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
localparam A = 2'b00;
localparam BC = 2'b01;
localparam D = 2'b10;

// State register
reg [1:0] state;

// Counter instance
wire [1:0] count;
counter counter_inst(
    .clk(clk),
    .areset(areset),
    .enable((state == BC) && in),
    .count(count)
);

// Next state logic
always @(posedge clk or posedge areset)
begin
    if(areset)
        state <= A;
    else
    begin
        case(state)
            A:
            begin
                if(in)
                    state <= BC;
                else
                    state <= A;
            end
            BC:
            begin
                if(count == 2'b01 && in)
                    state <= D;
                else if(in)
                    state <= BC;
                else
                    state <= A;
            end
            D:
            begin
                if(in)
                    state <= BC;
                else
                    state <= A;
            end
        endcase
    end
end

// Output logic
assign out = (state == D);

endmodule