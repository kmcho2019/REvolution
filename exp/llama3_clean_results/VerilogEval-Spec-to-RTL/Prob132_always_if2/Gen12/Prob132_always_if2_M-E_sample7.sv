// Module for the Computer's Finite State Machine
module ComputerFSM(
    input      cpu_overheated,
    input      clk, // Clock signal for sequential logic
    input      rst, // Reset signal
    output reg shut_off_computer
);
    reg [0:0] state; // Current state of the FSM
    parameter ON = 1'b0, OFF = 1'b1;

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state <= ON;
            shut_off_computer <= 1'b0;
        end else begin
            case (state)
                ON: begin
                    if (cpu_overheated) begin
                        state <= OFF;
                        shut_off_computer <= 1'b1;
                    end
                end
                OFF: begin
                    if (!cpu_overheated) begin
                        state <= ON;
                        shut_off_computer <= 1'b0;
                    end
                end
                default: state <= ON;
            endcase
        end
    end
endmodule

// Module for the Car's Finite State Machine
module CarFSM(
    input      arrived,
    input      gas_tank_empty,
    input      clk, // Clock signal for sequential logic
    input      rst, // Reset signal
    output reg keep_driving
);
    reg [0:0] state; // Current state of the FSM
    parameter DRIVING = 1'b0, STOPPED = 1'b1;

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state <= DRIVING;
            keep_driving <= 1'b1;
        end else begin
            case (state)
                DRIVING: begin
                    if (arrived || gas_tank_empty) begin
                        state <= STOPPED;
                        keep_driving <= 1'b0;
                    end
                end
                STOPPED: begin
                    if (!arrived &&!gas_tank_empty) begin
                        state <= DRIVING;
                        keep_driving <= 1'b1;
                    end
                end
                default: state <= DRIVING;
            endcase
        end
    end
endmodule

// Top-level module
module TopModule (
    input      cpu_overheated,
    output     shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output     keep_driving,
    input      clk, // Clock signal
    input      rst  // Reset signal
);
    // Instantiate ComputerFSM and CarFSM modules
    ComputerFSM cfsm(
      .cpu_overheated(cpu_overheated),
      .clk(clk),
      .rst(rst),
      .shut_off_computer(shut_off_computer)
    );

    CarFSM cfs(
      .arrived(arrived),
      .gas_tank_empty(gas_tank_empty),
      .clk(clk),
      .rst(rst),
      .keep_driving(keep_driving)
    );
endmodule