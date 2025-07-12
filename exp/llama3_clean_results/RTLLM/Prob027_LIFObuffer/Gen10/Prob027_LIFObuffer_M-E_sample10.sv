module LIFObuffer #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [DATA_WIDTH-1:0] dataOut
);

// Modular Stack Memory (MSM) Module
module MSM #(
    parameter BUFFER_SIZE = 4,
    parameter DATA_WIDTH = 4
) (
    input [DATA_WIDTH-1:0] dataIn,
    output [DATA_WIDTH-1:0] dataOut,
    input push,
    input pop,
    input reset,
    output reg EMPTY,
    output reg FULL
);

reg [DATA_WIDTH-1:0] stack_mem [0:BUFFER_SIZE-1]; // Stack memory
reg [BUFFER_SIZE-1:0] SP; // Stack pointer

always @(posedge Clk) begin
    if (reset) begin // Active high reset
        SP <= BUFFER_SIZE; // Initialize stack pointer to BUFFER_SIZE (empty buffer)
        for (int i = 0; i < BUFFER_SIZE; i++) begin
            stack_mem[i] <= {DATA_WIDTH{1'b0}}; // Initialize stack memory to 0
        end
        dataOut <= {DATA_WIDTH{1'b0}};
    end else begin
        if (push &&!FULL) begin // Push operation
            stack_mem[SP-1] <= dataIn; // Push data onto stack
            SP <= SP - 1; // Decrement stack pointer
        end else if (pop &&!EMPTY) begin // Pop operation
            dataOut <= stack_mem[SP]; // Pop data from stack
            stack_mem[SP] <= {DATA_WIDTH{1'b0}}; // Clear popped data
            SP <= SP + 1; // Increment stack pointer
        end
    end
end

assign EMPTY = (SP == BUFFER_SIZE); // Buffer is empty when SP is equal to BUFFER_SIZE
assign FULL = (SP == 0); // Buffer is full when SP is 0

endmodule

// Control Logic (CL) Module
module CL #(
    parameter BUFFER_SIZE = 4
) (
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg push,
    output reg pop,
    output reg reset
);

always @(posedge Clk) begin
    if (Rst) begin
        push <= 1'b0;
        pop <= 1'b0;
        reset <= 1'b1;
    end else if (EN) begin
        if (!RW) begin // Write operation
            push <= 1'b1;
            pop <= 1'b0;
            reset <= 1'b0;
        end else begin // Read operation
            push <= 1'b0;
            pop <= 1'b1;
            reset <= 1'b0;
        end
    end else begin
        push <= 1'b0;
        pop <= 1'b0;
        reset <= 1'b0;
    end
end

endmodule

// Flag Generation (FG) Module
module FG #(
    parameter BUFFER_SIZE = 4
) (
    input EMPTY,
    input FULL,
    output reg EMPTY_FLAG,
    output reg FULL_FLAG
);

assign EMPTY_FLAG = EMPTY;
assign FULL_FLAG = FULL;

endmodule

// Instantiate modules
MSM #(
   .BUFFER_SIZE(BUFFER_SIZE),
   .DATA_WIDTH(DATA_WIDTH)
) msm_inst (
   .dataIn(dataIn),
   .dataOut(dataOut),
   .push(push),
   .pop(pop),
   .reset(reset),
   .EMPTY(EMPTY),
   .FULL(FULL)
);

CL #(
   .BUFFER_SIZE(BUFFER_SIZE)
) cl_inst (
   .RW(RW),
   .EN(EN),
   .Rst(Rst),
   .Clk(Clk),
   .push(push),
   .pop(pop),
   .reset(reset)
);

FG #(
   .BUFFER_SIZE(BUFFER_SIZE)
) fg_inst (
   .EMPTY(EMPTY),
   .FULL(FULL),
   .EMPTY_FLAG(EMPTY),
   .FULL_FLAG(FULL)
);

endmodule