module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    // Define the states of the FSM
    enum logic [1:0] {
        Idle,
        ShutDown,
        Drive,
        Refuel,
        ArrivedState
    } state, next_state;

    // Initialize the state
    initial state = Idle;

    // Combinational logic to determine the next state
    always @(*) begin
        case (state)
            Idle: begin
                if (cpu_overheated) next_state = ShutDown;
                else if (~arrived && ~gas_tank_empty) next_state = Drive;
                else if (~arrived && gas_tank_empty) next_state = Refuel;
                else if (arrived) next_state = ArrivedState;
                else next_state = Idle;
            end
            ShutDown: begin
                if (~cpu_overheated) next_state = Idle;
                else next_state = ShutDown;
            end
            Drive: begin
                if (cpu_overheated) next_state = ShutDown;
                else if (arrived) next_state = ArrivedState;
                else if (gas_tank_empty) next_state = Refuel;
                else next_state = Drive;
            end
            Refuel: begin
                if (cpu_overheated) next_state = ShutDown;
                else if (~gas_tank_empty) next_state = Drive;
                else next_state = Refuel;
            end
            ArrivedState: begin
                if (cpu_overheated) next_state = ShutDown;
                else next_state = ArrivedState;
            end
        endcase
    end

    // Sequential logic to update the state
    always @(posedge cpu_overheated or posedge arrived or posedge gas_tank_empty) begin
        state = next_state;
    end

    // Output logic
    always @(*) begin
        case (state)
            ShutDown: begin
                shut_off_computer = 1;
                keep_driving = 0;
            end
            Drive: begin
                shut_off_computer = 0;
                keep_driving = 1;
            end
            default: begin
                shut_off_computer = 0;
                keep_driving = 0;
            end
        endcase
    end

endmodule